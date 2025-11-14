// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:async';
import 'dart:js' as js;

html.EventListener? _popStateListener;
bool _isInitialized = false;
Timer? _historyMaintenanceTimer;

void initializeBrowserHistoryBlocker() {
  if (_isInitialized) {
    return;
  }

  // Inject JavaScript to intercept back button at the lowest level
  js.context.callMethod('eval', [
    '''
    (function() {
      // Store original pushState
      const originalPushState = history.pushState;
      const originalReplaceState = history.replaceState;
      
      // Override pushState to mark our states
      history.pushState = function(state, title, url) {
        const newState = state && typeof state === 'object' 
          ? {...state, _blocker: true} 
          : {_blocker: true, originalState: state};
        return originalPushState.call(history, newState, title || '', url || location.href);
      };
      
      // Override replaceState to mark our states
      history.replaceState = function(state, title, url) {
        const newState = state && typeof state === 'object' 
          ? {...state, _blocker: true} 
          : {_blocker: true, originalState: state};
        return originalReplaceState.call(history, newState, title || '', url || location.href);
      };
      
      // Create buffer states
      history.replaceState({_blocker: true}, '', location.href);
      for (let i = 0; i < 5; i++) {
        history.pushState({_blocker: true}, '', location.href);
      }
      
      // Intercept popstate with highest priority
      window.addEventListener('popstate', function(e) {
        e.stopImmediatePropagation();
        e.preventDefault();
        
        // Immediately push states back
        history.replaceState({_blocker: true}, '', location.href);
        history.pushState({_blocker: true}, '', location.href);
        history.pushState({_blocker: true}, '', location.href);
        history.pushState({_blocker: true}, '', location.href);
      }, true);
    })();
    ''',
  ]);

  // Also set up Dart-side listener as backup
  html.window.history.replaceState(
    {'blocker': true},
    '',
    html.window.location.href,
  );

  for (int i = 0; i < 5; i++) {
    html.window.history.pushState(
      {'blocker': true},
      '',
      html.window.location.href,
    );
  }

  _popStateListener = (html.Event event) {
    final currentUrl = html.window.location.href;
    html.window.history.replaceState({'blocker': true}, '', currentUrl);
    html.window.history.pushState({'blocker': true}, '', currentUrl);
    html.window.history.pushState({'blocker': true}, '', currentUrl);
  };

  html.window.addEventListener('popstate', _popStateListener!, true);

  // Maintain history buffer
  _historyMaintenanceTimer = Timer.periodic(const Duration(milliseconds: 500), (
    timer,
  ) {
    if (html.window.history.length < 5) {
      html.window.history.pushState(
        {'blocker': true},
        '',
        html.window.location.href,
      );
    }
  });

  _isInitialized = true;
}

void disposeBrowserHistoryBlocker() {
  if (_popStateListener != null) {
    html.window.removeEventListener('popstate', _popStateListener!, true);
    _popStateListener = null;
    _isInitialized = false;
  }
  _historyMaintenanceTimer?.cancel();
  _historyMaintenanceTimer = null;
}
