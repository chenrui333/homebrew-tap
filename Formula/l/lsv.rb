class Lsv < Formula
  desc "Three Pane Terminal File Viewer"
  homepage "https://github.com/SecretDeveloper/lsv"
  url "https://static.crates.io/crates/lsv/lsv-0.1.15.crate"
  sha256 "d8a22aec62790b5940ec28a6ef648fbd21f2487005d98e4773c0c636fa1d1f2d"
  license "MIT"
  head "https://github.com/SecretDeveloper/lsv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e9adfc5323bdd538f78950d23de6067486bbc500b4266f1174583871403f5fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "764d3314cc392d1cbfa6b14c51a486dd08fa894e15e08f3b78b7f6ac9c6632fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eaed3b9638e42218823decb8c4af6a5bdc199fecbc5c56efe56dea3553724cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efcb2243d1d2814f43674c3ea37264684ff4b94c5dfb963b163034322688f231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8273c2e4e4cf01bd77d2b8fea10f7f347663861dfcd313e7de41d13706609bf"
  end

  depends_on "rust" => :build

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
