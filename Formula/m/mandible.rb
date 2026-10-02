class Mandible < Formula
  desc "Interactive reference for installed command-line tools"
  homepage "https://github.com/AS-FOSS/mandible"
  url "https://github.com/AS-FOSS/mandible/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "ac3afb3d7ac675a4ba9d1780fc1180e5a4e9cf67fcce72cf491ec466400bb384"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/AS-FOSS/mandible.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "172f73c3c9180e72171585e3f8b4cd59e26ca7e96b1fb886b217f66a107d5e67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1da73a58532d20a4bb0d058aa9af544e8bcd84f4d2990f64909f77f5404eac1"
    sha256 cellar: :any,                 arm64_linux:   "916b2568d8dea6d7a49e188604485f960dff0ced54f34cf90e0412fe784a5d5f"
    sha256 cellar: :any,                 x86_64_linux:  "7e8d24827fadee7d91435ebde1aeb81b81490941686b8f8be63307534dfe792e"
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
