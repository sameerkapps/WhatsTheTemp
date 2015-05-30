// includes
#require "twitter.class.nut:1.1.0"

// keys from twitter
const API_KEY = "";

const API_SECRET = "";

const ACCESS_TOKEN = "";

const TOKEN_SECRET = "";

const SiteUrl = "https://sameerkapps.wordpress.com/2015/05/30/whats-the-temperature/";

// Create twitter
twitter <- Twitter(API_KEY, API_SECRET, ACCESS_TOKEN, TOKEN_SECRET);

// Agent listens to the tweet
// when tweet occurs, it asks data from the device

twitter.stream("howhot", function(tweetData) {
    AskTempToDevice(tweetData);
});

twitter.stream("howcold", function(tweetData) {
    AskTempToDevice(tweetData);
});

function AskTempToDevice(tweetData)
{
    if(device.isconnected())
    {
        server.log("ScreenName: " + tweetData.user.screen_name);
        device.send("saytemp", tweetData.user.screen_name);
    }
    else
    {
        local tweetString = "@" + tweetData.user.screen_name + " Thanks for asking. But the device is offline :(.";
        tweetString += "\nIn the meantime check this-> " + SiteUrl;
        server.log("Tweet offline" + tweetString);
        twitter.tweet(tweetString);
    }
}

// when device sends data, it tweets the temperature
device.on("heartemp", function(deviceData) {
    // conert Celsius to Fahrenheit
    local tempF = (9*deviceData.temperature)/5 + 32;
    server.log("Data From Device: " + tempF);
    local tweetString = "@" + deviceData.user + " the temperature is: " + tempF;
    tweetString += "\nHow is it done? Check this: " + SiteUrl;
    server.log("TweetString: " + tweetString);
    twitter.tweet(tweetString);
});
