require 'owner'

class OwnerRepository
  def all

    owners = []

    sql = 'SELECT id, user_id FROM owners;'
    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|

      owner = Owner.new
      owner.id = record['id'].to_i
      owner.user_id = record['user_id'].to_i
   
      owners << owner
    end
      return owners
    end
end