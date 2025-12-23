class Turm < Formula
  desc "TUI for the Slurm Workload Manager"
  homepage "https://github.com/kabouzeid/turm"
  url "https://github.com/kabouzeid/turm/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "93d12cc663073548d413b669354477bce11ee52ebc297ea212b6aa6a808b9250"
  license "MIT"
  head "https://github.com/kabouzeid/turm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31820062f806d2324ef0843381451b480c86b378e464d2cb67c140f903a469a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "067a9a366fd912fe7eaa4804bd40469418b83625ae5b9528136cc5668f764553"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3682a98d7f0b095cd1f0c9f8478c63a35dbed508bdb1db40272e54d1ee18acb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bce9211dc003cc66d26e520e9fb0e93bf118831a308db03516da150cdf1b4e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58041234d62b9f93d35f78583eeca82dacd9771dbaecda44023a1421bb876ba4"
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
