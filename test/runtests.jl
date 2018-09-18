using Zomato
using Compat.Test

# More comprehensive tests needed!
@test typeof(Zomato.Auth("apikey")) == Zomato.Auth