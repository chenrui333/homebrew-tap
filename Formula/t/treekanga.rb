class Treekanga < Formula
  desc "Manage Git worktrees from the command-line"
  homepage "https://github.com/garrettkrohn/treekanga"
  url "https://github.com/garrettkrohn/treekanga/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "8d56742bc18622063cf4ce45c2adb4f9bf493f31b14bfe6187b5dd9f8462a00e"
  license :cannot_represent
  head "https://github.com/garrettkrohn/treekanga.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f626b4b01df536c9c9f04934f983ff757f1d924af418d410c5ec7a914891691d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f626b4b01df536c9c9f04934f983ff757f1d924af418d410c5ec7a914891691d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db49437a323cdb658b08a4d3590477bf60fcd7aeae062b7c3bbadf3bf52033d3"
    sha256 cellar: :any,                 x86_64_linux:  "f83b6238ed2c7982dc17fd1c71ba4c0b73262c9db7bc0823706286523f81c6a8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
