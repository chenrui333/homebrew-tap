class Treekanga < Formula
  desc "Manage Git worktrees from the command-line"
  homepage "https://github.com/garrettkrohn/treekanga"
  url "https://github.com/garrettkrohn/treekanga/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "37eb5f7d89c5bba36dfd325cbacff0630dbffdd8ca238cf85169c79618efdafc"
  license :cannot_represent
  head "https://github.com/garrettkrohn/treekanga.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    config_dir = testpath/".config"/"treekanga"
    config_dir.mkpath
    (config_dir/"treekanga.yaml").write("repos: {}\n")

    (testpath/"source").mkpath
    cd testpath/"source" do
      system "git", "init", "-b", "main"
      (testpath/"source"/"README.md").write("hello\n")
      system "git", "add", "README.md"
      system "git", "-c", "user.name=Test", "-c", "user.email=test@example.com", "commit", "-m", "init"
    end

    (testpath/"workspace").mkpath
    with_env(HOME: testpath.to_s) do
      cd testpath/"workspace" do
        output = shell_output("#{bin/"treekanga"} clone #{testpath/"source"}")
        assert_match "Successfully cloned source_bare", output
        assert_path_exists testpath/"workspace"/"source_bare"/"HEAD"
        assert_path_exists testpath/"workspace"/"source_bare"/"config"
      end
    end
  end
end
