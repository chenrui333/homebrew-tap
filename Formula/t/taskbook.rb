class Taskbook < Formula
  desc "Tasks, boards & notes for the command-line habitat"
  homepage "https://taskbook.sh"
  url "https://github.com/taskbook-sh/taskbook/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "6ac61632ef47ca49d40b102dda00fb482f6f7597a758eea31d9c6cef0ece48a8"
  license "MIT"
  head "https://github.com/taskbook-sh/taskbook.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd8a95f898435cff98a2f632840495c6091d133d841e7805ac6e755b5e5c8174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a486f7e68cd696d2193afb4de6e7d87ddb90b6f41d217e8c79f76c7efaba8f47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfe4dc1533af4955851934da4cc3bca7aa544a8eb9ab3041d52a0607df982588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a94be314e4873c5bc4fbe3ee45a0f816a918e834dfc39915eb119c72edc4dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53c06120f8e2fe456204b8abdade23c406d9a0574dcf66daf83d5444be2d62bc"
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
