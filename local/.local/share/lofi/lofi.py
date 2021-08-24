#!/usr/bin/env python

from apiclient.discovery import build
from apiclient.errors import HttpError
from oauth2client.tools import argparser

from prompt_toolkit.shortcuts import radiolist_dialog
from os import environ


# Set DEVELOPER_KEY to the API key value from the APIs & auth > Registered apps
# tab of
#   https://cloud.google.com/console
# Please ensure that you have enabled the YouTube Data API for your project.
DEVELOPER_KEY = environ.get("DEVELOPER_KEY")
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION = "v3"

def youtube_search(options):
  youtube = build(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION,
    developerKey=DEVELOPER_KEY)

  # Call the search.list method to retrieve results matching the specified
  # query term.
  search_response = youtube.search().list(
    q=options.q,
    part="id,snippet",
    type="video",
    eventType="live",
    maxResults=options.max_results
  ).execute()

  videos = []

  # Add each result to the appropriate list, and then display the lists of
  # matching videos, channels, and playlists.
  for search_result in search_response.get("items", []):
    if search_result["id"]["kind"] == "youtube#video":
      videos.append((search_result["id"]["videoId"],search_result["snippet"]["title"] ))

  result = radiolist_dialog(title=options.q, values=videos).run()

  print(f'https://www.youtube.com/watch?v={result}')


if __name__ == "__main__":
  argparser.add_argument("--q", help="Search term", default="Google")
  argparser.add_argument("--max-results", help="Max results", default=25)
  args = argparser.parse_args()

  try:
    youtube_search(args)
  except HttpError as e:
    print ( "An HTTP error {} occurred:\n{}".format(e.resp.status, e.content) )  
