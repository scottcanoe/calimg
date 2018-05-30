function seqSpecs = sequenceSpecs()

EventValues = 0.0 : 0.2 : 3.0;
Labels = {'-', ...
          '(A)BCD', 'A(B)CD', 'AB(C)D', 'ABC(D)', '-', ...
          '(D)CDA', 'D(C)BA', 'DC(B)A', 'DCB(A)', '-', ...
          '(A)BCD novT', 'A(B)CD novT', 'AB(C)D novT', 'ABC(D) novT', '-'};

seqSpecs.EventValues = EventValues;
seqSpecs.Labels = Labels;

end