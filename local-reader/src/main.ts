import PCSCLite from 'pcsclite'

const pcsc = PCSCLite();

pcsc.on('reader', (reader) => {

  reader.on('error', (err) => {
    console.log('Reader error', reader.name, err)
  })

  reader.on('status', function (status) {
    // console.log('Status(', this.name, '):', status);
    /* check what has changed */
    var changes = this.state ^ status.state;
    if (changes) {
      if ((changes & this.SCARD_STATE_EMPTY) && (status.state & this.SCARD_STATE_EMPTY)) {
        console.log("card removed");/* card removed */
        reader.disconnect(reader.SCARD_LEAVE_CARD, function (err) {
          if (err) {
            console.log(err);
          } else {
            console.log('Disconnected');
          }
        });
      } else if ((changes & this.SCARD_STATE_PRESENT) && (status.state & this.SCARD_STATE_PRESENT)) {
        console.log("card inserted");/* card inserted */

        reader.connect({ share_mode: this.SCARD_SHARE_SHARED }, function (err, protocol) {
          if (err) {
            console.log(err);
          } else {
            // console.log('Protocol(', reader.name, '):', protocol);

            reader.transmit(Buffer.from("90b8000007", "hex"), 4096, protocol, function (err, data) {
              if (err) { console.log(err); return; }
              console.log('Serial number', data);
            });
          }
        });

      }
    }
  });

  reader.on('end', function () {
    console.log('Reader', this.name, 'removed');
  });

})
