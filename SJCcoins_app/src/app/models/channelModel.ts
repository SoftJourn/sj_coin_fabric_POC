export class ChannelModel {
  currentChannel: string = "mychannel";
  channels: Array<Object>;
  lastResult: string;
  readyToCreate:boolean;
  readyToConnect:boolean;
  isConnected:boolean;
  peers:string = "peer0.org1.example.com:7051"; //v1.0.3
}
