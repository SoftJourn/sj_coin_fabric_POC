export class ChannelModel {
  currentChannel: string = "mychannel";
  channels: Array<Object>;
  lastResult: string;
  readyToCreate:boolean;
  readyToConnect:boolean;
  isConnected:boolean;
  peers:string = "localhost:7051, localhost:7056";
}
