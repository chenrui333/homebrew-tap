class Turm < Formula
  desc "TUI for the Slurm Workload Manager"
  homepage "https://github.com/kabouzeid/turm"
  url "https://github.com/kabouzeid/turm/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "6f1404336ba91be8b16a17f35cc3d24bce29538c1120005787d6abdb41d01536"
  license "MIT"
  head "https://github.com/kabouzeid/turm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0d4359901676be47cebac861049e55151d6aabd90a996a462582b5a6c389f76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d6747d2f75330633460746ef0635d9eae4c30b327641bd9aa84abb25e57cb3b"
    sha256 cellar: :any,                 arm64_linux:   "e96f5b4afbaf1b9f53cf47bbb9e554749dc39915fec119776d95770b5365f221"
    sha256 cellar: :any,                 x86_64_linux:  "895297b7167601d748d4bcb38085fc27535cae940fd49ef790ed4482b8aca695"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"turm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/turm --version")

    output = shell_output("#{bin}/turm --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
