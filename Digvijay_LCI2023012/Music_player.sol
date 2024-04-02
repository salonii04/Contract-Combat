// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library StringUtils {
    function concat(string memory _a, string memory _b) internal pure returns (string memory) {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory ab = new string(_ba.length + _bb.length);
        bytes memory bab = bytes(ab);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
        for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
        return string(bab);
    }
}

contract music_dapp{
    
    using StringUtils for string;

    uint256 listener_id_check;
    uint256 song_id_check;
    uint256 artist_id_check;

    struct Artist{
        string artist_name;
        uint256 artist_id;
        uint256 total_songs;
    }

    struct Listener{
        string listener_name;
        uint256 listener_id;
        uint256 songs_liked;
    }

    struct Song{
        string song_name;
        uint256 song_id;
        string artist;
        bytes32 song_hash;
        string genre;
        uint256 likes;
    }

    mapping(address => Listener) all_listeners;
    mapping(address => Artist) all_artists;
    mapping(uint256 => Song) all_songs;
    mapping(bytes32 => bool) is_song_hash_used;

    constructor(){
        listener_id_check = 0;
        artist_id_check = 0;
        song_id_check = 0;
        all_artists[msg.sender].total_songs = 0;
        all_songs[song_id_check].likes = 0;
    }

    event listener_added(address listener_add, string listener_name, uint256 listener_id);
    event artist_added(address artist_add, string artist_name, uint256 artist_id);
    event song_added(string song_name, string artist_name, uint256 song_id, string song_genre);
    event play_song(string song_name, string song_genre);
    event song_liked(string song_name, string song_genre);

    function Total_songs() public view returns(uint256){
        return song_id_check;
    }

    function add_listener(string memory _name)public{
        
        listener_id_check+=1;
        Listener storage new_Listener = all_listeners[msg.sender];
        new_Listener.listener_name = _name;
        new_Listener.listener_id = listener_id_check;

        emit listener_added(msg.sender, _name, listener_id_check);
    }

    function add_artist(string memory _name) public {
        artist_id_check+=1;
        Artist storage new_Artist = all_artists[msg.sender];
        new_Artist.artist_name = _name;
        new_Artist.artist_id = artist_id_check;

        emit artist_added(msg.sender, _name, artist_id_check);
    }

    function get_artist_details() public view returns(string memory , uint256, uint256){
        return(
            all_artists[msg.sender].artist_name,
            all_artists[msg.sender].artist_id,
            all_artists[msg.sender].total_songs
        );
    }

    function get_listener_details() public view returns(string memory, uint256, uint256){
        return(
            all_listeners[msg.sender].listener_name,
            all_listeners[msg.sender].listener_id,
            all_listeners[msg.sender].songs_liked
        );
    }

    function add_song(string memory _name, string memory _genre) public {
        song_id_check+=1;
        Song storage new_song = all_songs[song_id_check];
        new_song.song_id = song_id_check;
        new_song.song_name = _name;
        new_song.artist = all_artists[msg.sender].artist_name;
        new_song.genre = _genre;

        string memory hash_check = _name.concat(_genre);
        bytes32 _hash = sha256(abi.encodePacked(hash_check));
        new_song.song_hash = _hash;

        all_songs[song_id_check] = new_song;
        all_artists[msg.sender].total_songs+=1;
        is_song_hash_used[_hash] = true;

        emit song_added(_name, all_artists[msg.sender].artist_name, song_id_check, _genre);

    }

    function get_song_details(uint256 _song_id) public view returns(string memory, string memory, string memory, bytes32){
        return(
            all_songs[_song_id].song_name,
            all_songs[_song_id].artist,
            all_songs[_song_id].genre,
            all_songs[_song_id].song_hash
        );
    }

    function Play_song(string memory _name, string memory genre) public {
        emit play_song(_name, genre); 
    }

    function Like_song(uint256 song_id) public {
        all_songs[song_id].likes+=1;
        string memory songName = all_songs[song_id].song_name;
        string memory songGenre = all_songs[song_id].genre;
        all_listeners[msg.sender].songs_liked+=1;

        emit song_liked(songName, songGenre);

    }
}
