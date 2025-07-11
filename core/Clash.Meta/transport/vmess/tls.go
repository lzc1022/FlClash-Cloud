package vmess

import (
	"context"
	"crypto/tls"
	"errors"
	"net"

	"github.com/metacubex/mihomo/component/ca"
	tlsC "github.com/metacubex/mihomo/component/tls"
)

type TLSConfig struct {
	Host              string
	SkipCertVerify    bool
	FingerPrint       string
	ClientFingerprint string
	NextProtos        []string
	Reality           *tlsC.RealityConfig
}

func StreamTLSConn(ctx context.Context, conn net.Conn, cfg *TLSConfig) (net.Conn, error) {
	tlsConfig := &tls.Config{
		ServerName:         cfg.Host,
		InsecureSkipVerify: cfg.SkipCertVerify,
		NextProtos:         cfg.NextProtos,
	}

	var err error
	tlsConfig, err = ca.GetSpecifiedFingerprintTLSConfig(tlsConfig, cfg.FingerPrint)
	if err != nil {
		return nil, err
	}

	clientFingerprint := cfg.ClientFingerprint
	if tlsC.HaveGlobalFingerprint() && len(clientFingerprint) == 0 {
		clientFingerprint = tlsC.GetGlobalFingerprint()
	}
	if len(clientFingerprint) != 0 {
		if cfg.Reality == nil {
			if fingerprint, exists := tlsC.GetFingerprint(clientFingerprint); exists {
				utlsConn := tlsC.UClient(conn, tlsC.UConfig(tlsConfig), fingerprint)
				err = utlsConn.HandshakeContext(ctx)
				if err != nil {
					return nil, err
				}
				return utlsConn, nil
			}
		} else {
			return tlsC.GetRealityConn(ctx, conn, clientFingerprint, tlsConfig, cfg.Reality)
		}
	}
	if cfg.Reality != nil {
		return nil, errors.New("REALITY is based on uTLS, please set a client-fingerprint")
	}

	tlsConn := tls.Client(conn, tlsConfig)

	err = tlsConn.HandshakeContext(ctx)
	return tlsConn, err
}
