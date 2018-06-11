function seqSpecs = sequenceSpecs()

EventValues = 0.0 : 0.2 : 3.0;
Labels = {'-', ...
          '(A)B C D ', ' A(B)C D ', ' A B(C)D ', ' A B C(D)', '-', ...
          '(D)C B A ', ' D(C)B A ', ' D C(B)A ', ' D C B(A)', '-', ...
          '(A)B C D novT', ' A(B)C D novT', ' A B(C)D novT', ' A B C(D) novT', '-'};

seqSpecs.EventValues = EventValues;
seqSpecs.Labels = Labels;

end