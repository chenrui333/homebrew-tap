class Cozypkg < Formula
  desc "Cozy wrapper around Helm and Flux CD for local development"
  homepage "https://github.com/cozystack/cozypkg"
  url "https://github.com/cozystack/cozypkg/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "8ae439290ed31e9fbfc1ec0eebff71e2ac70f33ccd8361dea2f92324ad6c5681"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozypkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c59ad496e58067747e14adedd2c7f1e8efe6651a9227b1de9445460c3d62ea5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88f7f30905a986025eaa9592f12055ee27d74957855c6dd5024e4da1379bad26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29f8e74ee4deea433fc5b1f5bbcbf3b1008b04cf6d99efd4acd642d5cd8c5313"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06b7077d0bc23d83464657c8380e6d3018a620f1a05bb4fcb41981c3a32c3eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c9329a7f2932c79b4242df6dc80cf75efcc59df4cd00b3f7d7571fec7000641"
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
