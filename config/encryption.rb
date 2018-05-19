require 'encryption'
Encryption.config do |e|
  e.key = ENV['ENCRYPTION_KEY']
  e.iv = ENV['ENCRYPTION_IV']
  # e.cipher = 'camellia-128-ecb' # if you're feeling adventurous
end
