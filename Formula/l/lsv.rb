class Lsv < Formula
  desc "Three Pane Terminal File Viewer"
  homepage "https://github.com/SecretDeveloper/lsv"
  url "https://static.crates.io/crates/lsv/lsv-0.1.15.crate"
  sha256 "d8a22aec62790b5940ec28a6ef648fbd21f2487005d98e4773c0c636fa1d1f2d"
  license "MIT"
  head "https://github.com/SecretDeveloper/lsv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "990e19688eea20807033d0870d916fa79c90fa6a7fbf00be6be4094e11803ece"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25184c5f02d711724f7177f1092d136db03c3e659acd6524060616f35344ec18"
    sha256 cellar: :any,                 arm64_linux:   "2622dd224b2c00201661d76672355de1771d31cfa634ffcf3f6ae25d7bd08776"
    sha256 cellar: :any,                 x86_64_linux:  "e0540911ceb64f5b9744e4a0898c79d34f42f7cd3ef3c54fda64636a49701da8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsv --version")

    output = pipe_output("#{bin}/lsv --init-config", "y\n", 0)
    assert_match "This will create lsv config at: #{testpath}/.config/lsv", output
    assert_match "About config.context passed to actions", (testpath/".config/lsv/init.lua").read
  end
end
