class GitX < Formula
  desc "CLI extensions for Git that simplify common workflows"
  homepage "https://github.com/simeg/git-x"
  url "https://static.crates.io/crates/git-x/git-x-1.1.0.crate"
  sha256 "dac2f14a3f515d7be0793bdede677fcfabbae86429fbc61cc0df39521437589c"
  license "MIT"
  head "https://github.com/simeg/git-x.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62822ca3ac077e0ecac1544264dc6b6f53eaea620ffeecdacdcbace655690d4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a57cc648556d5922d3c352cb8969e17f52b7ea3f3a7b32a8fad565f56daee3c7"
    sha256 cellar: :any_skip_relocation, ventura:       "bd7514a6f02876a32f02d3dcf62822e2b567972c7824fea2917ecddb6495c99a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3e5889c9fa102c631fbba46777903e3ade322212b3068963b9dbf845d5c8b14"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "test@brew.sh"

    (testpath/"README.md").write("# test")
    system "git", "add", "README.md"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/git-x info")

    default_branch = OS.mac? ? "main" : "master"
    assert_match "Current branch: #{default_branch}", output
  end
end
