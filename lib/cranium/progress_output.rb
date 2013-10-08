require 'progressbar'

class Cranium::ProgressOutput

  def self.show_progress(title, total)
    progress_bar = create_progress_bar title, total
    yield progress_bar
    progress_bar.finish
  end



  private

  def self.create_progress_bar(title, total)
    if STDOUT.tty?
      ProgressBar.new(title, total, STDOUT)
    else
      NullProgressBar.new
    end
  end



  class NullProgressBar

    def inc
    end



    def finish
    end

  end

end
