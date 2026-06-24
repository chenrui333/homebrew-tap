class Taskbook < Formula
  desc "Tasks, boards & notes for the command-line habitat"
  homepage "https://taskbook.sh"
  url "https://github.com/taskbook-sh/taskbook/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e1da39f117ed7ccdd2a4ed0579e7a22b09e4572b9e8bc6f53d6978e9366b0f81"
  license "MIT"
  head "https://github.com/taskbook-sh/taskbook.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b7710a460cbadc70658d44eab8377963519af101b33ac5bad9d464976dac517"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a676cd3afcab0c72e8d670a452bbb6330d30dc97a9a6281fa49c8840ce5a4e30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f34b8ad0b777711b1ffc425b8355a9aae29b581afee3c96a76edc0fc3ae81e9e"
    sha256 cellar: :any,                 arm64_linux:   "8ba0f89a1b0bd2a5e96b1cf52b7659aa7c09569b85df3f14450904bb14bf7ee5"
    sha256 cellar: :any,                 x86_64_linux:  "39a59acc83216c7a4d558c396f4e0828715e62c6526f20167bc267a01654c49a"
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
