export class ChannelModel {
  currentChannel: string = "mychannel";
  channels: Array<Object>;
  lastResult: string;
  readyToCreate:boolean;
  readyToConnect:boolean;
  isConnected:boolean;
}
