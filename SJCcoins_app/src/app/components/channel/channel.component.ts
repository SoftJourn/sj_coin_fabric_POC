import { Component, OnInit } from '@angular/core';
import {DataService} from "../../services/data.service";
import {ChannelService} from "../../services/channel.service";

@Component({
  selector: 'app-channel',
  templateUrl: './channel.component.html',
  styleUrls: ['./channel.component.css']
})
export class ChannelComponent implements OnInit {

  constructor(public data:DataService, private channelService:ChannelService) { }

  public isEnabled:boolean = false;

  ngOnInit() {

  }

  getChannels():void {
    if (this.data.user.token) {
      this.isEnabled = true;
      this.channelService.getChannels();
    }
    else {
      this.isEnabled = false;
      console.log("Incorrect user token")
    }
  }

  createChannel():void {
    if (this.data.channel.channels && this.data.channel.channels.length > 0) {
      console.log("Channel already exists")
   }
   else {
      this.channelService.createChannel();
    }
  }

  joinChannel() {
    if (this.data.channel.isConnected) {
      console.log("already connected")
    }
    else {
      this.channelService.joinChannel();
    }
  }

}
