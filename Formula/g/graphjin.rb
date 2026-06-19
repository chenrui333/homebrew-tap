class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.41.tar.gz"
  sha256 "7b30ffde3a3ebabbe5497ac2ecf22ddff863cbc6f6a54ebdfaa8454593ec5da7"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3e166a27579c6871d849b168c1c3de122e454d04b6192aba51be66b9dd4a82c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1a2af2c41842f6620a870bd7f3889e47756144d9c5fe78b406619c79cfec4ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "969e9efbdbde03545da4d544144620cb6a9a2641b370fba46b4aedcea129a6f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0968d7b0b8c090f6bcbd9034b10e89b924884a46422cca1392bce620757c38f8"
    sha256 cellar: :any,                 x86_64_linux:  "fe0f457ae5ad56fb09925c783d5834f407dae2f9409d865d14950d4acc93fcd2"
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

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
