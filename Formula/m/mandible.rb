class Mandible < Formula
  desc "Interactive reference for installed command-line tools"
  homepage "https://github.com/AS-FOSS/mandible"
  url "https://github.com/AS-FOSS/mandible/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8a4cfe84c84c9f0aeff389fe78d668829c39d086052bb70e8bb232ea64296217"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/AS-FOSS/mandible.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27441b3f26071085305b5f03ce1bfedc6c1b6350aa8170bf3ac0c0825a27248d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbe7d7e2f8efb3c468409e75c24fcece56543aaa96846fa8095831569304315d"
    sha256 cellar: :any,                 arm64_linux:   "a5f1dc5398ce94313e2b7b4880b3c16992579a45216f02dfe3d5a8d2486eb78a"
    sha256 cellar: :any,                 x86_64_linux:  "9fe06c36a38dce9a4b82efbf1a4a6a4699dc12ce98bd584157436ac43441f731"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "mandible")
    generate_completions_from_executable(bin/"mandible", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mandible --version")
    output = shell_output("#{bin}/mandible 2>&1", 1)
    assert_match "no tool given", output
  end
end
