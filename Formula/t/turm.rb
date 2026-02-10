class Turm < Formula
  desc "TUI for the Slurm Workload Manager"
  homepage "https://github.com/kabouzeid/turm"
  url "https://github.com/kabouzeid/turm/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "15b0c3d4ec801a5bba16538e82e85bf6a8e32ee9f757842d574db282484162b3"
  license "MIT"
  head "https://github.com/kabouzeid/turm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df81a74238388151c4f7f4aaefdd9f905c0b64e4eb52e0958243776f627f19ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc55431aa84f9d99fc8634879deca787655ba3ac4be4da42dd1ad5f4bc239df8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7760a4d737b015a850e04e2f029afee08ae667d10ff6b1e7812a9a4b4a80a94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d73e4d31a7d814e7571f2945953360787ce9bfb99753e718f4c21b5c8eda5329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb1e0317e28fbc7873cf5100c3b79e2d120d945ebb7f2260de149e7b5703ce61"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"turm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/turm --version")
  end
end
