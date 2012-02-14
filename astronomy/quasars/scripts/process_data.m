data_directory = '../raw/';
processed_directory = '../processed/';

load([data_directory 'dla_qso']);

data = X;
wavelengths = wl;
responses = dla_pos;

save([processed_directory 'quasars'], ...
      'data', 'wavelengths', 'responses');