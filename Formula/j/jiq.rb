class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.26.0.tar.gz"
  sha256 "9823ab9202826180414ee6e761212928e6eded45e046811baaac3a53523dc491"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e5b9a5698fe656f83ff1cd857409a41f81ada872042ce7b4d47035bf360f4ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "477b128744a01ca3cc74804bd77676133534a564e9f05ffedbdebb2ab5c39359"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06747c81a961f6cf85324c136bdf9446baf11289bc80d4668ab412beee8827b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08e430e988363195f8b9ca17779ca48bbda6ae932eb6e1b967d98398308df9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc2b236184cede9f209a6f0b78de031a2cd853611d41a3b40a12c0142ee15eaa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiq --version")

    (testpath/"data.json").write("{}\n")
    empty_path = testpath/"empty"
    empty_path.mkpath
    output = shell_output("PATH=#{empty_path} #{bin}/jiq #{testpath}/data.json 2>&1", 1)
    assert_match "jq binary not found in PATH.", output
  end
end
