class Cozypkg < Formula
  desc "Cozy wrapper around Helm and Flux CD for local development"
  homepage "https://github.com/cozystack/cozypkg"
  url "https://github.com/cozystack/cozypkg/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "8ae439290ed31e9fbfc1ec0eebff71e2ac70f33ccd8361dea2f92324ad6c5681"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozypkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07b42e956af43540723db0021185214201e5f2a2c6d53646c66262ae86c42011"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd2045b66c66d0f655cd8f02e1cba303746fb7c6a5c9209c47090fff6df61b97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a21104e94835139819064b069ed6a46df50c04502908ebfb58d399800c09138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73f712e23dcd4e765b7cefbb2462ab0c492e65c63cce42c4ad3fc4730903996e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb65573db43863cca56f8094dd7670718de5fe1dee4f29bf9d8725f32a229848"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    generate_completions_from_executable(bin/"cozypkg", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozypkg --version")

    output = shell_output("#{bin}/cozypkg list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
