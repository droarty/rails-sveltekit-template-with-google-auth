namespace :frontend do
  desc "Install frontend dependencies and build SvelteKit to public/frontend"
  task prepare: :environment do
    system!("npm --prefix frontend install")
    system!("npm --prefix frontend run build")
  end

  desc "Build SvelteKit to public/frontend (dependencies must already be installed)"
  task build: :environment do
    system!("npm --prefix frontend run build")
  end

  private

  def system!(cmd)
    system(cmd) || abort("Command failed: #{cmd}")
  end
end
