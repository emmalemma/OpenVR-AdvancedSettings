#pragma once

#include <openvr.h>
#include <cmath>

namespace quaternion
{
inline vr::HmdQuaternion_t fromHmdMatrix34( vr::HmdMatrix34_t matrix )
{
    vr::HmdQuaternion_t q;

    q.w = sqrt( fmax( 0,
                      static_cast<double>( 1 + matrix.m[0][0] + matrix.m[1][1]
                                           + matrix.m[2][2] ) ) )
          / 2;
    q.x = sqrt( fmax( 0,
                      static_cast<double>( 1 + matrix.m[0][0] - matrix.m[1][1]
                                           - matrix.m[2][2] ) ) )
          / 2;
    q.y = sqrt( fmax( 0,
                      static_cast<double>( 1 - matrix.m[0][0] + matrix.m[1][1]
                                           - matrix.m[2][2] ) ) )
          / 2;
    q.z = sqrt( fmax( 0,
                      static_cast<double>( 1 - matrix.m[0][0] - matrix.m[1][1]
                                           + matrix.m[2][2] ) ) )
          / 2;
    q.x = copysign( q.x,
                    static_cast<double>( matrix.m[2][1] - matrix.m[1][2] ) );
    q.y = copysign( q.y,
                    static_cast<double>( matrix.m[0][2] - matrix.m[2][0] ) );
    q.z = copysign( q.z,
                    static_cast<double>( matrix.m[1][0] - matrix.m[0][1] ) );
    return q;
}

inline vr::HmdQuaternion_t multiply( const vr::HmdQuaternion_t& lhs,
                                     const vr::HmdQuaternion_t& rhs )
{
    return { ( lhs.w * rhs.w ) - ( lhs.x * rhs.x ) - ( lhs.y * rhs.y )
                 - ( lhs.z * rhs.z ),
             ( lhs.w * rhs.x ) + ( lhs.x * rhs.w ) + ( lhs.y * rhs.z )
                 - ( lhs.z * rhs.y ),
             ( lhs.w * rhs.y ) + ( lhs.y * rhs.w ) + ( lhs.z * rhs.x )
                 - ( lhs.x * rhs.z ),
             ( lhs.w * rhs.z ) + ( lhs.z * rhs.w ) + ( lhs.x * rhs.y )
                 - ( lhs.y * rhs.x ) };
}

inline vr::HmdQuaternion_t conjugate( const vr::HmdQuaternion_t& quat )
{
    return {
        quat.w,
        -quat.x,
        -quat.y,
        -quat.z,
    };
}

inline double getYaw( const vr::HmdQuaternion_t& quat )
{
    double yawResult
        = atan2( 2.0 * ( quat.y * quat.w + quat.x * quat.z ),
                 ( 2.0 * ( quat.w * quat.w + quat.x * quat.x ) ) - 1.0 );
    return yawResult;
}

inline double getPitch( const vr::HmdQuaternion_t& quat )
{
    // positive forward
    // negative behind

    double pitchResult
        = atan2( 2.0 * ( quat.x * quat.w + quat.y * quat.z ),
                 1.0 - 2.0 * ( quat.x * quat.x + quat.y * quat.y ) );
    //    double pitchResult
    //= atan2( 2.0 * ( quat.x * quat.w + quat.y * quat.z ),
    //      2.0 * ( quat.w * quat.w + quat.z * quat.z ) - 1.0 );
    return pitchResult;
}

inline double getRoll( const vr::HmdQuaternion_t& quat )
{
    double rollResult;
    double sinp = 2 * ( quat.w * quat.z - quat.y * quat.x );
    if ( std::abs( sinp ) >= 1 )

    {
        rollResult = std::copysign( 3.14159265358979323846 / 2, sinp );
    }
    else
    {
        rollResult = std::asin( sinp );
    }
    return rollResult;
}

inline vr::HmdQuaternion_t slerp(const vr::HmdQuaternion_t qa, vr::HmdQuaternion_t qb, double t) {
    // quaternion to return
     vr::HmdQuaternion_t qm = vr::HmdQuaternion_t();
    // Calculate angle between them.
    double cosHalfTheta = qa.w * qb.w + qa.x * qb.x + qa.y * qb.y + qa.z * qb.z;
    // if qa=qb or qa=-qb then theta = 0 and we can return qa
    if (abs(cosHalfTheta) >= 1.0){
        qm.w = qa.w;qm.x = qa.x;qm.y = qa.y;qm.z = qa.z;
        return qm;
    }

    if (cosHalfTheta < 0) {
      qb.w = -qb.w;
      qb.x = -qb.x;
      qb.y = -qb.y;
      qb.z = qb.z;
      cosHalfTheta = -cosHalfTheta;
    }
    double halfTheta = acos(cosHalfTheta);
    double sinHalfTheta = sqrt(1.0 - cosHalfTheta*cosHalfTheta);
    // if theta = 180 degrees then result is not fully defined
    // we could rotate around any axis normal to qa or qb
    if (fabs(sinHalfTheta) < 0.001){ // fabs is floating point absolute
        qm.w = (qa.w * 0.5 + qb.w * 0.5);
        qm.x = (qa.x * 0.5 + qb.x * 0.5);
        qm.y = (qa.y * 0.5 + qb.y * 0.5);
        qm.z = (qa.z * 0.5 + qb.z * 0.5);
        return qm;
    }
    double ratioA = sin((1 - t) * halfTheta) / sinHalfTheta;
    double ratioB = sin(t * halfTheta) / sinHalfTheta;
    //calculate Quaternion.
    qm.w = (qa.w * ratioA + qb.w * ratioB);
    qm.x = (qa.x * ratioA + qb.x * ratioB);
    qm.y = (qa.y * ratioA + qb.y * ratioB);
    qm.z = (qa.z * ratioA + qb.z * ratioB);
    return qm;
}

inline double norm(vr::HmdQuaternion_t &q)
{
    return sqrt(q.x*q.x+q.y*q.y+q.z*q.z+q.w*q.w);
}

inline void normalize(vr::HmdQuaternion_t &q)
{
    double n=norm(q);
    q.x/=n;
    q.y/=n;
    q.z/=n;
}


inline vr::HmdQuaternion_t slerp_2(const vr::HmdQuaternion_t q1,const vr::HmdQuaternion_t q2, double lambda) {
    // quaternion to return
     vr::HmdQuaternion_t qr = vr::HmdQuaternion_t();
    // Calculate angle between them.

     float dotproduct = q1.x * q2.x + q1.y * q2.y + q1.z * q2.z + q1.w * q2.w;
     float theta, st, sut, sout, coeff1, coeff2;

         // algorithm adapted from Shoemake's paper
      lambda=lambda/2.0;

     theta = (float) acos(dotproduct);
     if (theta<0.0) theta=-theta;

     st = (float) sin(theta);
     sut = (float) sin(lambda*theta);
     sout = (float) sin((1-lambda)*theta);
     coeff1 = sout/st;
     coeff2 = sut/st;

     qr.x = coeff1*q1.x + coeff2*q2.x;
     qr.y = coeff1*q1.y + coeff2*q2.y;
     qr.z = coeff1*q1.z + coeff2*q2.z;
     qr.w = coeff1*q1.w + coeff2*q2.w;

     normalize(qr);
     return qr;
}

inline vr::HmdQuaternion_t slerp_3(const vr::HmdQuaternion_t a,const vr::HmdQuaternion_t b, double t) {
    // quaternion to return
     vr::HmdQuaternion_t r = vr::HmdQuaternion_t();
    // Calculate angle between them.
    float t_ = 1 - t;
    float Wa, Wb;
    float theta = acos(a.x*b.x + a.y*b.y + a.z*b.z + a.w*b.w);
    float sn = sin(theta);
    Wa = sin(t_*theta) / sn;
    Wb = sin(t*theta) / sn;
    r.x = Wa*a.x + Wb*b.x;
    r.y = Wa*a.y + Wb*b.y;
    r.z = Wa*a.z + Wb*b.z;
    r.w = Wa*a.w + Wb*b.w;
    normalize(r);
    return r;
}
} // namespace quaternion
