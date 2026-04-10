class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.16.1.tar.gz"
  sha256 "5714b0cf194b14a6b39d7eaec5c203674c82d712178d43aafe7c07bcf5a90595"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a18ef66a1c682ccc6348fef33727b5943e9f0e504558012d6eedc7d9c1700e0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7e21d5bb3f779d28a2a8a35f3c4bf07760ae49d65018080704ba3e14441fc5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9edddbe494bf03e2e59c0932223a2fc4c1d05544d1287e228054727dd299973e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "202c4aa627df0f568fc019ce537043b9fbdfdc9f0fa849ea28f84d131658d5d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c7323a50bdc17dca5e2fa96e31021d87694dc83f9187a2f8fb8f9e7e2e5649f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
