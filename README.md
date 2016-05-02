## Conflict-free replicated data type

### Usage

Start console by running `irb -r ./app.rb`

Using simple memory store:
```ruby
lww_set = LWWSet.new(store: :memory)
lww_set.add('apple', Time.now.to_i)
lww_set.add('banana', Time.now.to_i)
lww_set.remove('apple', Time.now.to_i)
lww_set.exists?('apple')
# => false
lww_set.get
# => ["banana"]
```

Using Redis and Namespaces:
```ruby
lww_set = LWWSet.new(store: :redis, namespace: 'First')
lww_set.add('apple', Time.now.to_i)
lww_set.get
# => ["apple"]

lww_set = LWWSet.new(store: :redis, namespace: 'Second')
lww_set.add('banana', Time.now.to_i)
lww_set.get
# => ["banana"]

lww_set = LWWSet.new(store: :redis, namespace: 'First')
lww_set.add('orange', Time.now.to_i)
lww_set.get
# => ["apple", "orange"]
```
