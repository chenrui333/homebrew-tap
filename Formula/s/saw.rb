class Saw < Formula
  desc "Fast, multi-purpose tool for AWS CloudWatch Logs"
  homepage "https://github.com/TylerBrock/saw"
  url "https://github.com/TylerBrock/saw/archive/00fd4b4c7df009add8af2b7d6c1629cd174217fe.tar.gz"
  version "0.2.2"
  sha256 "958f80ff9fc38f7ae49adb3f48864a874dc9839d96406d30952b214f2b574e58"
  license "MIT"

  livecheck do
    skip "no recent releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3d9301bbae3b0de9fd5aedc42307af8355642d16f2875c02720877a0df9f2b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9bc515d4b545ffefb637269cbae323e5bc38e7c5a9a51fe54c55a924106e020"
    sha256 cellar: :any_skip_relocation, ventura:       "6224e2c0a28acefb2ce25bb6d053618f34b676ce1700b1f657c8ed96518d32d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b693ad4449edd4311fad8f14161b824890ce6062818bca1cbb0d6723f9a4c936"
  end

  depends_on "go" => :build

  patch :DATA

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saw version")

    ENV["AWS_REGION"] = "us-east-1"
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/saw groups 2>&1")
    assert_empty output
  end
end

__END__
diff --git a/go.sum b/go.sum
new file mode 100644
index 0000000..397ce0e
--- /dev/null
+++ b/go.sum
@@ -0,0 +1,48 @@
+github.com/TylerBrock/colorjson v0.0.0-20180527164720-95ec53f28296 h1:JYWTroLXcNzSCgu66NMgdjwoMHQRbv2SoOVNFb4kRkE=
+github.com/TylerBrock/colorjson v0.0.0-20180527164720-95ec53f28296/go.mod h1:VSw57q4QFiWDbRnjdX8Cb3Ow0SFncRw+bA/ofY6Q83w=
+github.com/aws/aws-sdk-go v1.13.56 h1:CFGN8C5W7w3bxo2eNuOZQJVPmKUhSXW1GSzFJjk/z6M=
+github.com/aws/aws-sdk-go v1.13.56/go.mod h1:ZRmQr0FajVIyZ4ZzBYKG5P3ZqPz9IHG41ZoMu1ADI3k=
+github.com/davecgh/go-spew v1.1.0 h1:ZDRjVQ15GmhC3fiQ8ni8+OwkZQO4DARzQgrnXU1Liz8=
+github.com/davecgh/go-spew v1.1.0/go.mod h1:J7Y8YcW2NihsgmVo/mv3lAwl/skON4iLHjSsI+c5H38=
+github.com/fatih/color v1.7.0 h1:DkWD4oS2D8LGGgTQ6IvwJJXSL5Vp2ffcQg58nFV38Ys=
+github.com/fatih/color v1.7.0/go.mod h1:Zm6kSWBoL9eyXnKyktHP6abPY2pDugNf5KwzbycvMj4=
+github.com/go-ini/ini v1.37.0 h1:/FpMfveJbc7ExTTDgT5nL9Vw+aZdst/c2dOxC931U+M=
+github.com/go-ini/ini v1.37.0/go.mod h1:ByCAeIL28uOIIG0E3PJtZPDL8WnHpFKFOtgjp+3Ies8=
+github.com/gopherjs/gopherjs v0.0.0-20181017120253-0766667cb4d1 h1:EGx4pi6eqNxGaHF6qqu48+N2wcFQ5qg5FXgOdqsJ5d8=
+github.com/gopherjs/gopherjs v0.0.0-20181017120253-0766667cb4d1/go.mod h1:wJfORRmW1u3UXTncJ5qlYoELFm8eSnnEO6hX4iZ3EWY=
+github.com/hokaccha/go-prettyjson v0.0.0-20180920040306-f579f869bbfe h1:MCgzztuoH5LZNr9AkIaicIDvCfACu11KUCCZQnRHDC0=
+github.com/hokaccha/go-prettyjson v0.0.0-20180920040306-f579f869bbfe/go.mod h1:pFlLw2CfqZiIBOx6BuCeRLCrfxBJipTY0nIOF/VbGcI=
+github.com/inconshreveable/mousetrap v1.0.0 h1:Z8tu5sraLXCXIcARxBp/8cbvlwVa7Z1NHg9XEKhtSvM=
+github.com/inconshreveable/mousetrap v1.0.0/go.mod h1:PxqpIevigyE2G7u3NXJIT2ANytuPF1OarO4DADm73n8=
+github.com/jmespath/go-jmespath v0.0.0-20160202185014-0b12d6b521d8 h1:12VvqtR6Aowv3l/EQUlocDHW2Cp4G9WJVH7uyH8QFJE=
+github.com/jmespath/go-jmespath v0.0.0-20160202185014-0b12d6b521d8/go.mod h1:Nht3zPeWKUH0NzdCt2Blrr5ys8VGpn0CEB0cQHVjt7k=
+github.com/jtolds/gls v4.20.0+incompatible h1:xdiiI2gbIgH/gLH7ADydsJ1uDOEzR8yvV7C0MuV77Wo=
+github.com/jtolds/gls v4.20.0+incompatible/go.mod h1:QJZ7F/aHp+rZTRtaJ1ow/lLfFfVYBRgL+9YlvaHOwJU=
+github.com/mattn/go-colorable v0.0.9 h1:UVL0vNpWh04HeJXV0KLcaT7r06gOH2l4OW6ddYRUIY4=
+github.com/mattn/go-colorable v0.0.9/go.mod h1:9vuHe8Xs5qXnSaW/c/ABM9alt+Vo+STaOChaDxuIBZU=
+github.com/mattn/go-isatty v0.0.3 h1:ns/ykhmWi7G9O+8a448SecJU3nSMBXJfqQkl0upE1jI=
+github.com/mattn/go-isatty v0.0.3/go.mod h1:M+lRXTBqGeGNdLjl/ufCoiOlB5xdOkqRJdNxMWT7Zi4=
+github.com/pmezard/go-difflib v1.0.0 h1:4DBwDE0NGyQoBHbLQYPwSUPoCMWR5BEzIk/f1lZbAQM=
+github.com/pmezard/go-difflib v1.0.0/go.mod h1:iKH77koFhYxTK1pcRnkKkqfTogsbg7gZNVY4sRDYZ/4=
+github.com/smartystreets/assertions v0.0.0-20180927180507-b2de0cb4f26d h1:zE9ykElWQ6/NYmHa3jpm/yHnI4xSofP+UP6SpjHcSeM=
+github.com/smartystreets/assertions v0.0.0-20180927180507-b2de0cb4f26d/go.mod h1:OnSkiWE9lh6wB0YB77sQom3nweQdgAjqCqsofrRNTgc=
+github.com/smartystreets/goconvey v0.0.0-20190330032615-68dc04aab96a h1:pa8hGb/2YqsZKovtsgrwcDH1RZhVbTKCjLp47XpqCDs=
+github.com/smartystreets/goconvey v0.0.0-20190330032615-68dc04aab96a/go.mod h1:syvi0/a8iFYH4r/RixwvyeAJjdLS9QV7WQ/tjFTllLA=
+github.com/spf13/cobra v0.0.3 h1:ZlrZ4XsMRm04Fr5pSFxBgfND2EBVa1nLpiy1stUsX/8=
+github.com/spf13/cobra v0.0.3/go.mod h1:1l0Ry5zgKvJasoi3XT1TypsSe7PqH0Sj9dhYf7v3XqQ=
+github.com/spf13/pflag v1.0.1 h1:aCvUg6QPl3ibpQUxyLkrEkCHtPqYJL4x9AuhqVqFis4=
+github.com/spf13/pflag v1.0.1/go.mod h1:DYY7MBk1bdzusC3SYhjObp+wFpr4gzcvqqNjLnInEg4=
+github.com/stretchr/objx v0.1.0/go.mod h1:HFkY916IF+rwdDfMAkV7OtwuqBVzrE8GR6GFx+wExME=
+github.com/stretchr/testify v1.3.0 h1:TivCn/peBQ7UY8ooIcPgZFpTNSz0Q2U6UrFlUfqbe0Q=
+github.com/stretchr/testify v1.3.0/go.mod h1:M5WIy9Dh21IEIfnGCwXGc5bZfKNJtfHm1UVUgZn+9EI=
+golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod h1:djNgcEr1/C05ACkg1iLfiJU5Ep61QUkGW8qpdssI0+w=
+golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod h1:t9HGtf8HONx5eT2rtn7q6eTqICYqUVnKs3thJo3Qplg=
+golang.org/x/net v0.0.0-20190613194153-d28f0bde5980 h1:dfGZHvZk057jK2MCeWus/TowKpJ8y4AmooUzdBSR9GU=
+golang.org/x/net v0.0.0-20190613194153-d28f0bde5980/go.mod h1:z5CRVTTTmAJ677TzLLGU+0bjPO0LkuOLi4/5GtJWs/s=
+golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a h1:1BGLXjeY4akVXGgbC9HugT3Jv3hCI0z56oJR5vAMgBU=
+golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod h1:STP8DvDyc/dI5b8T5hshtkjS+E42TnysNCUPdjciGhY=
+golang.org/x/text v0.3.0 h1:g61tztE5qeGQ89tm6NTjjM9VPIm088od1l6aSorWRWg=
+golang.org/x/text v0.3.0/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ=
+golang.org/x/tools v0.0.0-20190328211700-ab21143f2384/go.mod h1:LCzVGOaR6xXOjkQ3onu1FJEFr0SW1gC7cKk1uF8kGRs=
+gopkg.in/ini.v1 v1.42.0 h1:7N3gPTt50s8GuLortA00n8AqRTk75qOP98+mTPpgzRk=
+gopkg.in/ini.v1 v1.42.0/go.mod h1:pNLf8WUiyNEtQjuu5G5vTm06TEv9tsIgeAvK8hOrP4k=
