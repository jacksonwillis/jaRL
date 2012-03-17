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

  def apply fn, args, ctx=@env, ruby=false
    if @env[fn].respond_to? :call || ruby
      return ruby ? @env[fn].call(*args) : @env[fn].call(args, ctx)
    end

    raise NoMethodError, "Unknown uLithp function #{fn}" unless @env[fn]
    self.eval @env[fn][2], Hash[*(@env[fn][1].zip args).flatten(1)]
  end

  def eval sexpr, ctx=@env
    if @env[:atom].call [sexpr], ctx
      return ctx[sexpr] if ctx[sexpr]
      return sexpr
    end

    fn = sexpr[0]

    ruby = false
    if fn =~ /^\// # trying to call a ruby function
      ruby = true
      rfn = method(fn.to_s.sub(/^\//,''))
      @env[fn] = rfn
    elsif fn =~ /^\./ # trying to call a ruby method
      #ruby = true
      rfn = fn.to_s.sub(/^\./,'')
      @env[fn] = lambda { |a, _| a.map { |e| e.__send__(rfn) } }
    end

    args = (sexpr.drop 1)
    args = args.map { |a| self.eval(a, ctx) } if not [:quote, :if, :then, :else, :function].member? fn
    apply(fn, args, ctx, ruby)
  end
end
