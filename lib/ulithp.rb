# by Fogus
# http://joyofclojure.com
# https://github.com/fogus/ulithp/blob/master/lithp.rb

class Lisp
  def initialize(env = nil)
    @env = default_env
  end

  def default_env
    {
      :label => lambda { |(name,val), _| @env[name] = val },
      :quote => lambda { |sexpr, _| sexpr[0] },
      :car => lambda { |(list), _| list[0] },
      :cdr => lambda { |(list), _| list.drop 1 },
      :cons => lambda { |(e,cell), _| [e] + cell },
      :eq => lambda { |(l,r), _| l == r },
      :if => lambda { |(cond, thn, els), ctx| eval(cond, ctx) ? eval(thn, ctx) : eval(els, ctx) },
      :atom => lambda { |(sexpr), _| [Symbol, Numeric, String].map { |klass| sexpr.is_a? klass }.any? }
    }
  end

  def apply fn, args, ctx=@env, ruby_method=false
    if @env[fn].respond_to? :call
      return ruby_method ? @env[fn].call(*args) : @env[fn].call(args, ctx)
    end

    self.eval @env[fn][2], Hash[*(@env[fn][1].zip args).flatten(1)]
  end

  def eval sexpr, ctx=@env
    if @env[:atom].call [sexpr], ctx
      return ctx[sexpr] if ctx[sexpr]
      return sexpr
    end

    fn = sexpr[0]

    ruby_method = fn =~ /^\// # trying to call a ruby function
    if ruby_method
      rfn = method(fn.to_s.sub(/^\//,''))
      @env[fn] = rfn
    end

    args = (sexpr.drop 1)
    args = args.map { |a| self.eval(a, ctx) } if not [:quote, :if].member? fn
    apply(fn, args, ctx, ruby_method)
  end
end
