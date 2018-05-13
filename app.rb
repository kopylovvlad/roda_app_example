Cuba.define do
  on get do
    on root do
      res.redirect '/hello'
    end

    on 'hello' do
      on root do
        res.write 'Hello world!'
      end
    end

    on "search" do
      on root do
        on param("q") do |query|
          res.write "Searched for #{query}" #=> "Searched for barbaz"
        end

        # If the params `1` is not provided, this
        # block will get executed.
        on true do
          res.write "You need to provide q-params!"
        end
      end
    end


  end


  on 'users' do
    res.write 'it is GET users'
  end
  #on get do
  #end

  on 'users2' do
    on root do
      on get do

      end

      on post do
      end
    end

    on ':id' do
      on root do
        on get do
          res.write 'it is GET users/:id'
        end

        on patch do
        end
        on put do
        end
      end
    end
  end
end
