class Cozypkg < Formula
  desc "Cozy wrapper around Helm and Flux CD for local development"
  homepage "https://github.com/cozystack/cozypkg"
  url "https://github.com/cozystack/cozypkg/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "167f184beceb030a1d15dd941bc7d2f90a89a97e9268eba98dfe94a2ca586e7f"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozypkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b65253e975bdb409687f7690b4cd6530f918ec82b8b6fce9cd3b591cf1793e13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84153ba6099285721318dade9062d1fbee83effe51a9354a5ed8dafe797b15ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b304cbb40a753342a2297b8a0d15e22d8fccf5898b48a59158aa260dc74b023c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "722aca783d8929594e26f6d4de67ca70971b041c748184e2fb630ed71cd5c394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32099d0cca88f5da529c0fb77f3e29700a50c293b18ad084954bc4c853585993"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    generate_completions_from_executable(bin/"cozypkg", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozypkg --version")

    output = shell_output("#{bin}/cozypkg list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
