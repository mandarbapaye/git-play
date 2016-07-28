module I18n
  module Backend
    module Memoize
      def available_locales
        @memoized_locales ||= super
      end

      def store_translations(locale, data, options = {})
        reset_memoizations!(locale)
        super
      end

      def reload!
        reset_memoizations!
        super
      end

      protected

        def lookup(locale, key, scope = nil, options = {})
          flat_key  = I18n::Backend::Flatten.normalize_flat_keys(locale,
            key, scope, options[:separator]).to_sym
          flat_hash = memoized_lookup[locale.to_sym]
          flat_hash.key?(flat_key) ? flat_hash[flat_key] : (flat_hash[flat_key] = super)
        end

        def memoized_lookup
          @memoized_lookup ||= Hash.new { |h, k| h[k] = {} }
        end

        def reset_memoizations!(locale=nil)
          @memoized_locales = nil
          (locale ? memoized_lookup[locale.to_sym] : memoized_lookup).clear
        end
    end
  end
end
