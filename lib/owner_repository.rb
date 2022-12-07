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

    def find(id)
      sql = 'SELECT id, user_id FROM owners WHERE id = $1;'
      result_set = DatabaseConnection.exec_params(sql, [id])
  
      owner = Owner.new
      owner.id = result_set[0]['id'].to_i
      owner.user_id = result_set[0]['user_id']

      return owner
    end

    def create(owner)
      sql = 'INSERT INTO owners (user_id) VALUES($1);'
      sql_params = [owner.user_id]
      
      DatabaseConnection.exec_params(sql, sql_params)
  
      return nil
    end
  end
