# framework: kong
class Aiac < Formula
  desc "Artificial Intelligence Infrastructure-as-Code Generator"
  homepage "https://github.com/gofireflyio/aiac"
  url "https://github.com/gofireflyio/aiac/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "45e48cd8958d835b402e0e68d7aa8b9642deb535464dad5d6b83fb8f8ed3d79e"
  license "Apache-2.0"
  head "https://github.com/gofireflyio/aiac.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e491fbfa86013efd005352c93c1280dd568693179d7aeeb187c7fea7ea44790b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd5111308ae6925aa821ea6cf48d8824f87bba160b1d4403165ddfc8bab953fa"
    sha256 cellar: :any_skip_relocation, ventura:       "d12042e3f28612d4f077c72dc3e487879b34ef80a80f3f1f70ec622cc7c5d306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53df1c4ab3ad4cb1327a2d61603bc6f213dae090e54b9f740fdf44379c51ddf9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/gofireflyio/aiac/v#{version.major}/libaiac.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath

    # tailored from https://github.com/gofireflyio/aiac?tab=readme-ov-file#configuration
    (testpath/"aiac/aiac.toml").write <<~YAML
      default_backend = "official_openai"   # Default backend when one is not selected

      [backends.official_openai]
      type = "openai"
      api_key = "API KEY"
      default_model = "gpt-4o"              # Default model to use for this backend

      [backends.localhost]
      type = "ollama"
      url = "http://localhost:11434/api"     # This is the default
    YAML

    output = shell_output("#{bin}/aiac --list-models 2>&1", 1)
    assert_match "Incorrect API key provided: API KEY", output

    assert_match version.to_s, shell_output("#{bin}/aiac --version")
  end
end
