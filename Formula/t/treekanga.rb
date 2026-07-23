class Treekanga < Formula
  desc "Manage Git worktrees from the command-line"
  homepage "https://github.com/garrettkrohn/treekanga"
  url "https://github.com/garrettkrohn/treekanga/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "aba47f10a922d5c08b0ebde1395603a71da0142a58e49896da96f6fd9b531b5a"
  license :cannot_represent
  head "https://github.com/garrettkrohn/treekanga.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ecc414374a64d7aa14ee7c576ee03ab1b17e045c280744b812506e71e852f95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ecc414374a64d7aa14ee7c576ee03ab1b17e045c280744b812506e71e852f95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ecc414374a64d7aa14ee7c576ee03ab1b17e045c280744b812506e71e852f95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9e2eafc01c4604cebcdf6363ef5338b5f6f1c94ec263f5485b57a07bd2ef430"
    sha256 cellar: :any,                 x86_64_linux:  "502caa1af5df6027074b00d6ad17a9d1ef50589666c3217fa3f3c5725afc009d"
  end

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
