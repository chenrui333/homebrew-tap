class Taskbook < Formula
  desc "Tasks, boards & notes for the command-line habitat"
  homepage "https://taskbook.sh"
  url "https://github.com/taskbook-sh/taskbook/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "86e63a776a11e4b597f9b3c453f7712953eff186fd5462c555611cb035210f5c"
  license "MIT"
  head "https://github.com/taskbook-sh/taskbook.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03590370bac49137987e3f0abb1d7b2449bc80f20670c066f601d4bed622e9a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6f0e9e870e3226abe4c6cb3572d883fa3ac2a62289eec07dc026ab9e274b722"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6798cbe0527fa683dd62da9b6fbfe3c7165e89e890253c5daafa7ddcddf316e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3a40d7cc5662bad83bb3fdc7ab9de48cd1c96326dbc2b4a2b97efad82c3df5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0b76339e88ee1a0181ea45272164f09f1b64580d4f2bfd718df57c862bd4813"
  end

  depends_on "rust" => :build

  def install
    ENV["CARGO_TARGET_DIR"] = buildpath/"target"

    system "cargo", "install", *std_cargo_args(path: "crates/taskbook-client")
    system "cargo", "install", *std_cargo_args(path: "crates/taskbook-server")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tb --version")

    system bin/"tb", "--cli", "--taskbook-dir", testpath, "--task", "Ship formula"
    output = shell_output("#{bin}/tb --cli --taskbook-dir #{testpath} --list pending")
    assert_match "Ship formula", output
  end
end
