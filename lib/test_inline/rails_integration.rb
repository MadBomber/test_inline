class Test::Inline::Railtie < Rails::Railtie

  # Anything under app/models should use ActiveRecord::TestCase
  initializer 'test_inline.register.activerecord_testcase' do
    Test::Inline.register_abstract_test_case \
      Regexp.new(Regexp.escape(Rails.root.join('app/models'))),
      ActiveRecord::TestCase
  end

  # Anything under app/controllers should use ActionController::TestCase
  # Since the TestCase has no name we need to configure controller_class
  initializer 'test_inline.register.actioncontroller_testCase' do
    Test::Inline.register_abstract_test_case \
      Regexp.new(Regexp.escape(Rails.root.join('app/controllers'))),
      ActionController::TestCase do |klass, path|
      zap = Regexp.escape Rails.root.join('app/controllers')
      path = path.sub Regexp.new('^' + zap), ''
      path = path.sub(/\.rb$/, '')
      klass.controller_class = path.camelize.constantize
    end
  end

  # Anything under app/helpers should use ActionView::TestCase
  # Since the TestCase has no name we need to configure helper_class
  initializer 'test_inline.register.actionview_testcase' do
    require 'action_view/test_case'
    Test::Inline.register_abstract_test_case \
      Regexp.new(Regexp.escape(Rails.root.join('app/helpers'))),
      ActionView::TestCase do |klass, path|
      zap = Regexp.escape Rails.root.join('app/helpers')
      path = path.sub Regexp.new('^' + zap), ''
      path = path.sub(/\.rb/, '')
      klass.helper_class = path.camelize.constantize
    end
  end

  # Anything under lib uses ActiveSupport::TestCase
  initializer 'test_inline.register.activesupport_testcase' do
    Test::Inline.register_abstract_test_case \
      Regexp.new(Regexp.escape(Rails.root.join('lib'))),
      ActiveSupport::TestCase
  end

  # We provide tasks for running unit and functional tests (or both)
  rake_tasks do
    load "test_inline/tasks/test_inline.rake"
  end
end