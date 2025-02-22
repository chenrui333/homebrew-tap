class Awless < Formula
  desc "Mighty CLI for AWS"
  homepage "https://github.com/wallix/awless"
  url "https://github.com/wallix/awless/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "1a78636face8753cb983a5e4c1e3bfc9e1940e7eb932aa01fe2cbded46fd4292"
  license "Apache-2.0"
  head "https://github.com/wallix/awless.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74c67a675156a6f76aff5f9fade1ff3f36f9e667efd74406412de600ef249649"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e47d4806158c9d3174e06ad3d2dea290195e50fe6ab009dc62fcf0fb7b9bdde"
    sha256 cellar: :any_skip_relocation, ventura:       "9d560556530b144ed72353c05b8dc5ef0a93138383311937b0c2f83e59bddb3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37736ecf5ead07dadf69452c9e7023ec3268100cb3ed80dea80f06e960c03eb5"
  end

  depends_on "go" => :build

  # go mod patch
  patch do
    url "https://raw.githubusercontent.com/chenrui333/homebrew-tap/ca236873fc69417984cbe1c0edaa38952928d3d9/patches/awless/0.1.11-go-mod.patch"
    sha256 "1495fb4edfc94d6ea595271b422b4a90f284850a411aef528a4fd229fa71cfc7"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=readonly"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awless version")

    ENV["AWS_REGION"] = "us-east-1"
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/awless list instances --local")
    assert_match "No results found", output
  end
end
