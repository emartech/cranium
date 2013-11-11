module Cranium::ImportStrategy

  autoload :Base, 'cranium/import_strategy/base'
  autoload :DeleteInsert, 'cranium/import_strategy/delete_insert'
  autoload :Delta, 'cranium/import_strategy/delta'
  autoload :Merge, 'cranium/import_strategy/merge'

end