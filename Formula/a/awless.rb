class Awless < Formula
  desc "Mighty CLI for AWS"
  homepage "https://github.com/wallix/awless"
  url "https://github.com/wallix/awless/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "1a78636face8753cb983a5e4c1e3bfc9e1940e7eb932aa01fe2cbded46fd4292"
  license "Apache-2.0"
  head "https://github.com/wallix/awless.git", branch: "master"

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
