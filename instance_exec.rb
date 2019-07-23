require 'bundler/setup'
Bundler.require(:default)

class Serializer
  def user_path(id)
    "/user/#{id}"
  end
end

class User
  def id
    1
  end
end

lambda_test1 = ->(user, serializer) { serializer.user_path(user.id) }
lambda_test2 = ->(user) { user_path(user.id) }

serializer = Serializer.new
user = User.new

Benchmark.ips do |x|
  x.config(:time => 10, :warmup => 2)

  x.report("arg passing") {
    lambda_test1.call(user, serializer)
  }

  x.report("instance_exec") {
    serializer.instance_exec(user, &lambda_test2)
  }

  x.compare!
end


#Warming up --------------------------------------
#         arg passing   193.690k i/100ms
#       instance_exec   175.730k i/100ms
#Calculating -------------------------------------
#         arg passing      3.194M (± 3.9%) i/s -     31.959M in  10.022354s
#       instance_exec      2.627M (± 4.1%) i/s -     26.360M in  10.053750s

#Comparison:
#         arg passing:  3194134.1 i/s
#       instance_exec:  2626788.6 i/s - 1.22x  slower
