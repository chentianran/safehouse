class FieldTitles
   @title = {  'name' => 'Name',
               'familyname'=> 'Family Name',
               'familydesc'=> 'Family Description',
               'desc'=> 'Description',
               'dim'=> 'Dimension',
               'tdeg'=> 'Total Degree', 
               'mvol'=> 'Mixed Volume', 
               'emvol'=> 'Mixed Volume (ext.)', 
               'soln_count_c'=> 'Isolated solutions', 
               'soln_count_r'=> 'Isolated real solutions',
               'ref'=> 'Reference',
               'eq_sym'=> 'Equations',
               'eq_hps'=> 'Equations (HOM4PS format)',
               'solns_c'=> 'Isolated solutions',
               'solns_r'=> 'Isolated real solutions',
               'comp'=> 'Components of positive dimensions',
               'posdim'=> 'Has positive dimensional components',
               'open'=> 'Open problem' }

   def self.titleOf(field)
      return @title[field]
   end
end
