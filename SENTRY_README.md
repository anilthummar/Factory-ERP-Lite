_# Sentry_Readme

1. # Add sentryDSN to Environment Files
   Ensure you have added the sentryDSN key to both stage_env.json and prod_env.json

2. #  SentryService Class :-
   The SentryService class contains all the necessary methods related to log API logs in sentry.
   This class contains capture event and exception event.

   **SentryService.captureEvent() => Capture a custom event in Sentry.**

   **SentryService.captureException() => Capture an exception in Sentry.**


#  To find the HTTP logs in sentry dashboard navigate to :- 
   Performance module => All Transaction => 
   Select the API end point in transaction => Sampled Events =>
   Select the event id => find the response in Additional data tab.