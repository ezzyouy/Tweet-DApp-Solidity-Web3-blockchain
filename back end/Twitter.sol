// SPDX-License-Identifier: MIT

     
pragma solidity >0.7.0<0.9.0;


contract Twitter {
    uint16 public MAX_TWEET_LENGTH=280;
    struct Tweet{
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    
    mapping(address=>Tweet[]) public tweets;
    address public owner;

    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLike(address liker, address tweetAuthor, uint256 tweetId, uint256 newLikecount);
    event TweetUnlike(address unliker, address tweetAuthor, uint256 tweetId, uint256 newLikecount);

    constructor() {
        owner=msg.sender;
    }
    modifier OnlyOwner{
        require(msg.sender == owner,"you are not the owner");
        _;
    }

    function changeTweetLength(uint16 newTweetLength) public OnlyOwner {
        MAX_TWEET_LENGTH =newTweetLength;
    }

    function createTweet(string memory _tweet) public{

        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is to long bro!");
        Tweet memory newTweet= Tweet({
            id:tweets[msg.sender].length,
            author:msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes:0
        });
        tweets[msg.sender].push( newTweet);

        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);

    }

    function likeTweet(address _owner, uint256 _id) external {
        require(tweets[_owner][_id].id== _id,"Tweet does not exist!!!");
        tweets[_owner][_id].likes++;

        emit TweetLike(msg.sender, _owner, _id, tweets[_owner][_id].likes);
    }

    function unlikeTweet(address _author, uint256 _id) external {
         require(tweets[_author][_id].id== _id,"Tweet does not exist!!!");
         require(tweets[_author][_id].likes > 0," Tweet has no likes");
        tweets[_author][_id].likes--;

        emit TweetUnlike(msg.sender, _author, _id, tweets[_author][_id].likes);
    }

    function getTweet( uint _i) public view returns (Tweet memory) {
        
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory){
        return tweets[_owner];
    }
}